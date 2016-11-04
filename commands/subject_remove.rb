require_relative '../commands/command.rb'

class Subject_remove < Command

  def initialize(bot, user_id, database)
    @dialog_step = 1
    @bot = bot
    @user_id = user_id
    @database = database

    @database.set('users', user_id)
  end

  def give_answer(message)
    case @dialog_step
      when 1 then remove_subject
      when 2 then send_ok(message)
    end
  end

  def Subject_remove.check_name(text)
    text == '/subject_remove'
  end

  def remove_subject
    @labs = JSON.parse(@database.hget(@user_id, 'subjects')).keys
    answer = "Какой предмет удалим?\n"

    @labs.each_with_index { |value, key|
      answer += "#{key + 1}. #{value}\n"
    }

    @bot.api.send_message(chat_id: @user_id, text: answer)

    @dialog_step = 2
  end

  def send_ok(message)
    unless message.lstrip =~ /\d+/ &&   message.to_i <= @labs.size && message.to_i > 0
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return @dialog_step
    end

    @subject_number = message.to_i - 1

    subjects = JSON.parse(@database.hget(@user_id, 'subjects'))
    subjects.delete(@labs[@subject_number])

    @database.hset(@user_id, 'subjects', subjects.to_json)

    @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADvwIAAj-VzApwbWy_7hwjawI")

    @dialog_step = 0
  end

end
