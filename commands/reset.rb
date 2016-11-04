require_relative '../commands/command.rb'

class Reset < Command

  def initialize(bot, user_id, database)
    @dialog_step = 1
    @bot = bot
    @user_id = user_id
    @database = database

    @database.set('users', user_id)
  end

  def Reset.check_name(name)
    name == '/reset'
  end

  def give_answer(text)
    @database.del(@user_id, 'subjects')
    @database.del(@user_id, 'start_date')
    @database.del(@user_id, 'finish_date')

    @bot.api.send_sticker(chat_id: @user_id, sticker: "BQADAgADkAIAAj-VzAoAARgigP6YrAcC")

    @dialog_step = 0
  end
end