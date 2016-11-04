require_relative '../commands/command.rb'

class Semester < Command

  def initialize(bot, user_id, database)
    @dialog_step = 1
    @bot = bot
    @user_id = user_id
    @database = database

    @database.set('users', user_id)
  end

  def get_dialog_step
    @dialog_step
  end

  def Semester.check_name(name)
    name == '/semester'
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
    clean_message = message.lstrip
    pattern = /((0[1-9]|[12]\d)-(0[1-9]|1[012])|(30-0[13-9]|1[012])|(31-0[13578]|1[02]))-20\d\d/

    unless clean_message =~ pattern
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return  @dialog_step
    end

    @database.hmset(@user_id, 'start_date', message)

    @bot.api.send_message(chat_id: @user_id, text: "Когда конец занятий? (дд-мм-гггг)")
    @dialog_step = 3
  end

  def send_all_time(message)
    clean_message = message.lstrip
    pattern = /((0[1-9]|[12]\d)-(0[1-9]|1[012])|(30-0[13-9]|1[012])|(31-0[13578]|1[02]))-20\d\d/

    unless clean_message =~ pattern
      @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADzwIAAj-VzAqZJmrw1nWAUAI")

      return @dialog_step
    end

    start_date = Date.strptime(@database.hget(@user_id, 'start_date'), '%d-%m-%Y')
    finish_date = Date.strptime(message, '%d-%m-%Y')

    available_time = (finish_date - start_date).to_i

    if available_time <= 0
      @bot.api.send_message(chat_id: @user_id, text: "Некорректно набрана дата")

      return @dialog_step
    end

    @database.hmset(@user_id, 'finish_date', message)

    message = "На все про все у тебя #{available_time} #{decline(available_time, 'дней', 'день', 'дня')}"

    @bot.api.send_message(chat_id: @user_id, text: message)

    @dialog_step = 0
  end

end


