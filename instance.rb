class MatchInstance
  attr_accessor :type, :minutes, :person, :country

  def initialize(value)
    # Set defaults
    @type = InstanceType::UNKNOWN
    @minutes = 0
    @person = 'Andrews'
    @country = 'England'

    @value = value
    determineType()
    determineCountry()
    determineMinutes()
    determinePerson()
  end

  # All methods below this point are private
  private

  # What country scored/had a player sent off?
  def determineCountry
    @country = 'England'
  end

  # When did the instance happen?
  def determineMinutes
    if @type == InstanceType::HALF_TIME
      @minutes = 45
    elsif @type == InstanceType::FULL_TIME
      @minutes = 90
    elsif @type == InstanceType::GOAL
      mins = @value.search("strong[@class='minutesIntoMatch']")
      if mins.any?
        @minutes = mins[0].inner_html.strip
      end
    end
  end


  # Who was involved in the instance?
  def determinePerson
    @person = 'Andrews'
  end

  # What was the type of instance
  def determineType
    html = @value.inner_html
    id = @value.attributes['id']

    if html.include? 'GOAL: '
      @type = InstanceType::GOAL
    elsif id.include? '_HalfTime'
      @type = InstanceType::HALF_TIME
    elsif id.include? '_FullTime'
      @type = InstanceType::FULL_TIME
    elsif html.include? 'SENT OFF:'
      @type = InstanceType::SENT_OFF

  end

end

class InstanceType
  GOAL      = 1
  SENT_OFF  = 2
  HALF_TIME = 3
  FULL_TIME = 4
  UNKNOWN   = 5
end

