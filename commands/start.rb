require_relative '../commands/command.rb'

class Start < Command

  def initialize(bot, user_id, database)
    @dialog_step = 1
    @bot = bot
    @user_id = user_id
    @database = database
  end

  def Start.check_name(name)
    name == '/start'
  end

  def give_answer(text)
    result_string = "Привет, я твой персональный помощник, я помогу сдать тебе все лабы. Смотри, что я умею: \n"
    keys = DESC_COMMANDS.keys

    keys.each do |command|
      result_string = result_string + "#{command} - #{DESC_COMMANDS[command]}\n"
    end

    @bot.api.send_message(chat_id: @user_id, text: result_string)

    @dialog_step = 0
  end

end