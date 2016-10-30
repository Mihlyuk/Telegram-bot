class Subject
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
      when 2 then when_end_learning(message)
    end
  end

  def teach_subject
    @bot.api.send_message(chat_id: @user_id, text: "Какой предмет учим?")

    @dialog_step = 2
  end

  def labs_count(message)
    pattern = /((0[1-9]|1[012])-(0[1-9]|[12]\d)|(0[13-9]|1[012])-30|(0[13578]|1[02])-31)-20\d\d/

    unless message =~ pattern
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return @dialog_step
    end
  end

end