class Submit

  def initialize(bot, user_id, database)
    @dialog_step = 1
    @bot = bot
    @user_id = user_id
    @database = database

    @database.set('users', user_id)
  end

  def give_answer(message)
    case @dialog_step
      when 1 then what_passed
      when 2 then what_lab(message)
      when 3 then send_ok(message)
    end
  end

  def what_passed
    @labs = JSON.parse(@database.hget(@user_id, 'subjects')).keys

    answer = "Что сдавал?\n"
    @labs.each_with_index { |value, key|
      answer += "#{key + 1}. #{value}\n"
    }

    @bot.api.send_message(chat_id: @user_id, text: answer)

    @dialog_step = 2
  end

  def what_lab(message)
    unless message.lstrip =~ /\d+/ && message.to_i <= @labs.size
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return @dialog_step
    end
    @subject_number = message.to_i - 1
    @bot.api.send_message(chat_id: @user_id, text: 'Какая лаба?')

    @dialog_step = 3
  end

  def send_ok(message)
    subjects = JSON.parse(@database.hget(@user_id, 'subjects'))
    subject_name = @labs[@subject_number]
    subject = subjects[subject_name]
    made_labs = JSON.parse(subject['made_labs'])

    unless message.lstrip =~ /\d+/ && message.to_i <= made_labs.size
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return @dialog_step
    end

    made_labs[message.to_i - 1] = true

    subjects[subject_name]['made_labs'] = made_labs.to_json
    @database.hset(@user_id, 'subjects', subjects.to_json)

    @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADvwIAAj-VzApwbWy_7hwjawI")

    @dialog_step = 0
  end

end