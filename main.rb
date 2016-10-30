require 'telegram/bot'
require 'redis'

require_relative './commands/start.rb'
require_relative './commands/semester.rb'
require_relative './commands/subject.rb'

token = '282969345:AAEkW0070hAfVNlqKasIPvNYF076ANBSoMs'

database = Redis.new
puts database.ping

DESC_COMMANDS = {
    '/start' => 'Выводит приветствие и описание всех доступных команд',
    '/semester' => 'Запоминает даты начала и конца семестра',
    '/subject' => 'Добавляет предмет и количество лабораторных работ по нему',
    '/status' => 'Выводит твой список лаб, которые тебе предстоит сдать',
    '/reset' => 'Сбрасывает для пользователя все данные.'
}

active_commands = []

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

    case message.text
      when '/start'
        active_commands.clear
        command = Start.new(bot, message.from.id, database)
        wait_answer = command.give_answer
        active_commands.push command if wait_answer > 0
      when '/semester'
        active_commands.clear
        command = Semester.new(bot, message.from.id, database)
        wait_answer = command.give_answer(message.text)
        active_commands.push command if wait_answer > 0
      when '/subject'
        active_commands.clear
        command = Subject.new(bot, message.from.id, database)
        wait_answer = command.give_answer(message.text)
        active_commands.push command if wait_answer > 0
      else
        if active_commands.size > 0
          command = active_commands.pop
          wait_answer = command.give_answer(message.text)
          active_commands.push command if wait_answer

          next
        end
    end


  end
end
