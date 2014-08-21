class Disambiguator
  attr_reader :emitters

  def initialize(emitters)
    @emitters = emitters
  end

  def disambiguate!
    emitters.replace_each! do |emitter|
      disambiguate(emitter)
    end
  end

  private

  def disambiguate(emitter)
    if emitter.respond_to?(:disambiguate)
      emitter.disambiguate(emitters)
    else
      emitter
    end
  end
end
