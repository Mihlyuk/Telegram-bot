require_relative '../commands/command.rb'
require_relative '../constants/answer.rb'

class Reset < Command

  def initialize
    @subjects = {}
    @start_date = ''
    @finish_date = ''
  end

  def say(message)
    @dialog_step = 0

    Answer::OK
  end

  def to_json
    {
        subjects: @subjects,
        start_date: @start_date,
        finish_date: @finish_date
    }
  end

end