require_relative '../commands/command.rb'

class Subject < Command

  def initialize(bot, user_id, database)
    @dialog_step = 1
    @bot = bot
    @user_id = user_id
    @database = database

    @database.set('users', user_id)
  end

  def give_answer(message)
    case @dialog_step
      when 1 then teach_subject
      when 2 then labs_count(message)
      when 3 then send_OK(message)
    end
  end

  def Subject.check_name(text)
    text == '/subject'
  end

  def teach_subject
    @bot.api.send_message(chat_id: @user_id, text: 'Какой предмет учим?')

    @dialog_step = 2
  end

  def labs_count(message)
    clean_message = message.lstrip
    pattern = /[A-Za-zА-Яа-я\s]+/

    unless (clean_message =~ pattern) == 0
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return @dialog_step
    end

    @subject = clean_message

    @bot.api.send_message(chat_id: @user_id, text: 'Сколько лаб нужно сдать?')

    @dialog_step = 3
  end

  def send_OK(message)
    clean_message = message.lstrip

    unless (clean_message =~ /\d+/) == 0
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return @dialog_step
    end

    unless @database.hexists(@user_id, 'subjects')
      @database.hset(@user_id, 'subjects', {}.to_json)
    end

    labs_count = message.to_i
    subjects = JSON.parse(@database.hget(@user_id, 'subjects'))
    subjects[@subject] = {
        'labs_count' => labs_count,
        'made_labs' => Array.new(labs_count, false).to_json
    }

    @database.hset(@user_id, 'subjects', subjects.to_json)

    @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADkAIAAj-VzAoAARgigP6YrAcC")

    @dialog_step = 0
  end

end
