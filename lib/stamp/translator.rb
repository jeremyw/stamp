module Stamp
  class Translator

    # Full list of time zone abbreviations from
    # http://en.wikipedia.org/wiki/List_of_time_zone_abbreviations
    TIME_ZONE_ABBREVIATIONS = %w{
        ACDT ACST ACT ADT AEDT AEST AFT AKDT AKST AMST AMT ART AST AWDT AWST AZOST AZT
        BDT BIOT BIT BOT BRT BST BTTCAT CCT CDT CEDT CEST CET CHADT CHAST CHOT ChST CHUT
        CIST CIT CKT CLST CLT COST COT CST CT CVT CWST CXT DAVT DDUT DFT EASST EAST EAT
        ECT EDT EEDT EEST EET EGST EGT EIT EST FET FJT FKST FKT FNT GALT GAMT GET GFT
        GILT GIT GMT GST GYT HADT HAEC HAST HKT HMT HOVT HST ICT IDT IOT IRDT IRKT IRST
        IST JST KGT KOST KRAT KST LHST LINT MAGT MART MAWT MDT MET MEST MHT MIST MIT MMT
        MSK MST MUT MVT MYT NCT NDT NFT NPT NST NT NUT NZDT NZST OMST ORAT PDT PET PETT
        PGT PHOT PHT PKT PMDT PMST PONT PST RET ROTT SAKT SAMT SAST SBT SCT SGT SLT SRT
        SST SYOT TAHT THA TFT TJT TKT TLT TMT TOT TVT UCT ULAT UTC UYST UYT UZT VET VLAT
        VOLT VOST VUT WAKT WAST WAT WEDT WEST WET WST YAKT YEKT
      }

    TIMEZONE_REGEXP        = /^(#{TIME_ZONE_ABBREVIATIONS.join('|')})$/
    MONTHNAMES_REGEXP      = /^(#{Date::MONTHNAMES.compact.join('|')})$/i
    ABBR_MONTHNAMES_REGEXP = /^(#{Date::ABBR_MONTHNAMES.compact.join('|')})$/i
    DAYNAMES_REGEXP        = /^(#{Date::DAYNAMES.join('|')})$/i
    ABBR_DAYNAMES_REGEXP   = /^(#{Date::ABBR_DAYNAMES.join('|')})$/i

    ONE_DIGIT_REGEXP       = /^\d{1}$/
    TWO_DIGIT_REGEXP       = /^\d{2}$/
    FOUR_DIGIT_REGEXP      = /^\d{4}$/

    TIME_REGEXP            = /(\d{1,2})(:)(\d{2})(\s*)(:)?(\d{2})?(\s*)?([ap]m)?/i

    MERIDIAN_LOWER_REGEXP  = /^(a|p)m$/
    MERIDIAN_UPPER_REGEXP  = /^(A|P)M$/

    ORDINAL_DAY_REGEXP     = /^(\d{1,2})(st|nd|rd|th)$/

    # Disambiguate based on value
    OBVIOUS_24_HOUR        = 13..23
    OBVIOUS_DAY            = 13..31
    OBVIOUS_YEAR           = 32..99

    def translate(example)
      # extract any substrings that look like times, like "23:59" or "8:37 am"
      before, time_example, after = example.partition(TIME_REGEXP)

      # build emitters from the example date
      emitters = Emitters::Composite.new
      emitters << build_emitters(before.split(/\b/)) do |token|
        date_emitter(token)
      end

      # build emitters from the example time
      unless time_example.empty?
        time_parts = time_example.scan(TIME_REGEXP).first
        emitters << build_emitters(time_parts) do |token|
          time_emitter(token)
        end
      end

      # recursively process any remaining text
      emitters << translate(after) unless after.empty?
      emitters
    end

    # Transforms tokens that look like date/time parts to emitter objects.
    def build_emitters(tokens)
      tokens.map do |token|
        yield(token) || Emitters::String.new(token)
      end
    end

    def time_emitter(token)
      case token
      when MERIDIAN_LOWER_REGEXP
        Emitters::AmPm::LOWERCASE

      when MERIDIAN_UPPER_REGEXP
        Emitters::AmPm::UPPERCASE

      when TWO_DIGIT_REGEXP
        Emitters::Ambiguous.new(
          two_digit_hour_emitter(token),
          Emitters::TwoDigit::MIN,
          Emitters::TwoDigit::SEC)

      when ONE_DIGIT_REGEXP
        # 12-hour clock without leading zero
        Emitters::TwelveHour::NON_LEADING_ZERO
      end
    end

    def two_digit_hour_emitter(token)
      case token.to_i
      when OBVIOUS_24_HOUR
        # 24-hour clock
        Emitters::TwoDigit::HOUR
      else
        # 12-hour clock with leading zero
        Emitters::TwelveHour::LEADING_ZERO
      end
    end

    def date_emitter(token)
      case token
      when MONTHNAMES_REGEXP
        Emitters::Lookup.new(:month, Date::MONTHNAMES)

      when ABBR_MONTHNAMES_REGEXP
        Emitters::Lookup.new(:month, Date::ABBR_MONTHNAMES)

      when DAYNAMES_REGEXP
        Emitters::Lookup.new(:wday, Date::DAYNAMES)

      when ABBR_DAYNAMES_REGEXP
        Emitters::Lookup.new(:wday, Date::ABBR_DAYNAMES)

      when TIMEZONE_REGEXP
        Emitters::Delegate.new(:zone)

      when FOUR_DIGIT_REGEXP
        Emitters::Delegate.new(:year)

      when ORDINAL_DAY_REGEXP
        Emitters::Ordinal::DAY

      when TWO_DIGIT_REGEXP
        case token.to_i
        when OBVIOUS_DAY
          Emitters::TwoDigit::DAY
        when OBVIOUS_YEAR
          Emitters::TwoDigit::YEAR
        else
          Emitters::Ambiguous.new(
            Emitters::TwoDigit::MONTH,
            Emitters::TwoDigit::DAY,
            Emitters::TwoDigit::YEAR)
        end

      when ONE_DIGIT_REGEXP
        Emitters::Ambiguous.new(
          Emitters::Delegate.new(:month),
          Emitters::Delegate.new(:day))
      end
    end
  end
end
