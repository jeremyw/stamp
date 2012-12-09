module Stamp
  class StrftimeTranslator
    MONTHNAMES_REGEXP      = /^(#{Date::MONTHNAMES.compact.join('|')})$/i
    ABBR_MONTHNAMES_REGEXP = /^(#{Date::ABBR_MONTHNAMES.compact.join('|')})$/i
    DAYNAMES_REGEXP        = /^(#{Date::DAYNAMES.join('|')})$/i
    ABBR_DAYNAMES_REGEXP   = /^(#{Date::ABBR_DAYNAMES.join('|')})$/i

    # Full list of time zone abbreviations from http://en.wikipedia.org/wiki/List_of_time_zone_abbreviations
    TIMEZONE_REGEXP        = /^(ACDT|ACST|ACT|ADT|AEDT|AEST|AFT|AKDT|AKST|AMST|AMT|ART|AST|AST|AST|AST|AWDT|AWST|AZOST|AZT|BDT|BIOT|BIT|BOT|BRT|BST|BST|BTT|CAT|CCT|CDT|CDT|CEDT|CEST|CET|CHADT|CHAST|CHOT|ChST|CHUT|CIST|CIT|CKT|CLST|CLT|COST|COT|CST|CST|CST|CST|CST|CT|CVT|CWST|CXT|DAVT|DDUT|DFT|EASST|EAST|EAT|ECT|ECT|EDT|EEDT|EEST|EET|EGST|EGT|EIT|EST|EST|FET|FJT|FKST|FKT|FNT|GALT|GAMT|GET|GFT|GILT|GIT|GMT|GST|GST|GYT|HADT|HAEC|HAST|HKT|HMT|HOVT|HST|ICT|IDT|IOT|IRDT|IRKT|IRST|IST|IST|IST|JST|KGT|KOST|KRAT|KST|LHST|LHST|LINT|MAGT|MART|MAWT|MDT|MET|MEST|MHT|MIST|MIT|MMT|MSK|MST|MST|MST|MUT|MVT|MYT|NCT|NDT|NFT|NPT|NST|NT|NUT|NZDT|NZST|OMST|ORAT|PDT|PET|PETT|PGT|PHOT|PHT|PKT|PMDT|PMST|PONT|PST|PST|RET|ROTT|SAKT|SAMT|SAST|SBT|SCT|SGT|SLT|SRT|SST|SST|SYOT|TAHT|THA|TFT|TJT|TKT|TLT|TMT|TOT|TVT|UCT|ULAT|UTC|UYST|UYT|UZT|VET|VLAT|VOLT|VOST|VUT|WAKT|WAST|WAT|WEDT|WEST|WET|WST|YAKT|YEKT)$/

    ONE_DIGIT_REGEXP       = /^\d{1}$/
    TWO_DIGIT_REGEXP       = /^\d{2}$/
    FOUR_DIGIT_REGEXP      = /^\d{4}$/

    TIME_REGEXP            = /(\d{1,2})(:)(\d{2})(\s*)(:)?(\d{2})?(\s*)?([ap]m)?/i

    MERIDIAN_LOWER_REGEXP  = /^(a|p)m$/
    MERIDIAN_UPPER_REGEXP  = /^(A|P)M$/

    ORDINAL_DAY_REGEXP     = /^(\d{1,2})(st|nd|rd|th)$/

    # Disambiguate based on value
    OBVIOUS_YEARS          = 60..99
    OBVIOUS_MONTHS         = 12
    OBVIOUS_DAYS           = 13..31
    OBVIOUS_24_HOUR        = 13..23

    TWO_DIGIT_YEAR_EMITTER  = Emitters::NumericEmitter.new(:year, :leading_zero => true, :modifier => lambda { |year| year % 100 })
    TWO_DIGIT_MONTH_EMITTER = Emitters::NumericEmitter.new(:month, :leading_zero => true)
    TWO_DIGIT_DAY_EMITTER   = Emitters::NumericEmitter.new(:day, :leading_zero => true)
    HOUR_TO_12_HOUR         = lambda { |h| h = h % 12; h == 0 ? 12 : h }

    OBVIOUS_DATE_MAP = {
      OBVIOUS_YEARS  => TWO_DIGIT_YEAR_EMITTER,
      OBVIOUS_MONTHS => TWO_DIGIT_MONTH_EMITTER,
      OBVIOUS_DAYS   => TWO_DIGIT_DAY_EMITTER
    }

    TWO_DIGIT_DATE_SUCCESSION = {
      :month => TWO_DIGIT_DAY_EMITTER,
      :day   => TWO_DIGIT_YEAR_EMITTER,
      :year  => TWO_DIGIT_MONTH_EMITTER
    }

    TWO_DIGIT_TIME_SUCCESSION = {
      :hour => Emitters::NumericEmitter.new(:min, :leading_zero => true),
      :min  => Emitters::NumericEmitter.new(:sec, :leading_zero => true)
    }


    def translate(example)
      # extract any substrings that look like times, like "23:59" or "8:37 am"
      before, time_example, after = example.partition(TIME_REGEXP)

      # transform any date tokens to strftime directives
      words = Emitters::CompositeEmitter.new
      words << emitters(before.split(/([0-9a-zA-Z]+|%[a-zA-Z])/)) do |token, previous_part|
        date_emitter(token, previous_part)
      end

      # transform the example time string to strftime directives
      unless time_example.empty?
        time_parts = time_example.scan(TIME_REGEXP).first
        words << emitters(time_parts) do |token, previous_part|
          time_emitter(token, previous_part)
        end
      end

      # recursively process any remaining text
      words << translate(after) unless after.empty?
      words
    end

    # Transforms tokens that look like date/time parts to emitter objects.
    def emitters(tokens)
      previous_part = nil
      tokens.map do |token|
        if token =~ /^%/
          emitter = Emitters::StrftimeEmitter.new(token)
        else
          emitter = yield(token, previous_part)
          previous_part = emitter.field unless emitter.nil?
        end

        emitter || Emitters::StringEmitter.new(token)
      end
    end

    def time_emitter(token, previous_part)
      case token
      when MERIDIAN_LOWER_REGEXP
        Emitters::AmPmEmitter.new

      when MERIDIAN_UPPER_REGEXP
        Emitters::AmPmEmitter.new(:modifier => lambda { |v| v.upcase })

      when TWO_DIGIT_REGEXP
        TWO_DIGIT_TIME_SUCCESSION[previous_part] ||
          case token.to_i
          when OBVIOUS_24_HOUR
            # 24-hour clock
            Emitters::NumericEmitter.new(:hour, :leading_zero => true)
          else
            # 12-hour clock with leading zero
            Emitters::NumericEmitter.new(:hour, :leading_zero => true, :modifier => HOUR_TO_12_HOUR)
          end

      when ONE_DIGIT_REGEXP
        # 12-hour clock without leading zero
        Emitters::NumericEmitter.new(:hour, :modifier => HOUR_TO_12_HOUR)
      end
    end

    def date_emitter(token, previous_part)
      case token
      when MONTHNAMES_REGEXP
        Emitters::LookupEmitter.new(:month, Date::MONTHNAMES)

      when ABBR_MONTHNAMES_REGEXP
        Emitters::LookupEmitter.new(:month, Date::ABBR_MONTHNAMES)

      when DAYNAMES_REGEXP
        Emitters::LookupEmitter.new(:wday, Date::DAYNAMES)

      when ABBR_DAYNAMES_REGEXP
        Emitters::LookupEmitter.new(:wday, Date::ABBR_DAYNAMES)

      when TIMEZONE_REGEXP
        Emitters::DelegateEmitter.new(:zone)

      when FOUR_DIGIT_REGEXP
        Emitters::NumericEmitter.new(:year)

      when ORDINAL_DAY_REGEXP
        Emitters::OrdinalEmitter.new(:day)

      when TWO_DIGIT_REGEXP
        value = token.to_i

        obvious_mappings =
          OBVIOUS_DATE_MAP.reject { |k,v| v.field == previous_part }

        obvious_directive = obvious_mappings.find do |range, directive|
          break directive if range === value
        end

        # if the intent isn't obvious based on the example value, try to
        # disambiguate based on context
        obvious_directive ||
          TWO_DIGIT_DATE_SUCCESSION[previous_part] ||
          TWO_DIGIT_MONTH_EMITTER

      when ONE_DIGIT_REGEXP
        Emitters::NumericEmitter.new(:day)
      end
    end

  end
end
