class Semester

  def initialize(bot, user_id, database)
    @dialog_step = 1
    @bot = bot
    @user_id = user_id
    @database = database

    @database.set('users', user_id)
  end

  def give_answer(message)
    case @dialog_step
      when 1 then when_begin_learning
      when 2 then when_end_learning(message)
      when 3 then send_all_time(message)
    end
  end

  def when_begin_learning
    @bot.api.send_message(chat_id: @user_id, text: "Когда начинаем учиться? (дд-мм-гггг)")

    @dialog_step = 2
  end

  def when_end_learning(message)
    pattern = /((0[1-9]|1[012])-(0[1-9]|[12]\d)|(0[13-9]|1[012])-30|(0[13578]|1[02])-31)-(20\d\d)/

    unless message =~ pattern
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return @dialog_step
    end

    @database.hmset(@user_id, 'start_date', message)

    @bot.api.send_message(chat_id: @user_id, text: "Когда конец занятий? (дд-мм-гггг)")
    @dialog_step = 3
  end

  def send_all_time(message)
    pattern = /((0[1-9]|1[012])-(0[1-9]|[12]\d)|(0[13-9]|1[012])-30|(0[13578]|1[02])-31)-20\d\d/

    unless message =~ pattern
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return @dialog_step
    end

    @database.hmset(@user_id, 'finish_date', message)

    start_date = Date.strptime(@database.hget(@user_id, 'start_date'), '%d-%m-%Y')
    finish_date = Date.strptime(@database.hget(@user_id, 'finish_date'), '%d-%m-%Y')

    available_time = (finish_date - start_date).to_i

    message = "На все про все у тебя #{available_time} #{decline(available_time, 'дней', 'день', 'дня')}"

    @bot.api.send_message(chat_id: @user_id, text: message)

    @dialog_step = 0
  end

  def decline(number, first_dec, sec_dec, third_dec)
    string = number.to_s
    decisive_letter = string[string.length - 1]

    case decisive_letter
      when '0', '5', '6', '7', '8', '9' then return first_dec
      when '1' then return sec_dec
      when '2', '3', '4' then return third_dec
    end
  end

end