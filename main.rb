require 'telegram/bot'
require 'redis'
require 'json'

require_relative './commands/start.rb'
require_relative './commands/semester.rb'
require_relative './commands/subject.rb'
require_relative './commands/status.rb'
require_relative './commands/submit.rb'
require_relative './commands/reset.rb'

token = '282969345:AAEkW0070hAfVNlqKasIPvNYF076ANBSoMs'

database = Redis.new
puts database.ping

DESC_COMMANDS = {
    '/start' => 'Выводит описание всех доступных команд',
    '/semester' => 'Запоминает даты начала и конца семестра',
    '/subject' => 'Добавляет предмет и количество лабораторных работ по нему',
    '/subject_remove' => 'Удаляет предмет',
    '/status' => 'Выводит твой список лаб, которые тебе предстоит сдать',
    '/submit' => 'Запоминает какие предметы ты сдал',
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
      when '/status'
        active_commands.clear
        command = Status.new(bot, message.from.id, database)
        wait_answer = command.give_answer(message.text)
        active_commands.push command if wait_answer > 0
      when '/submit'
        active_commands.clear
        command = Submit.new(bot, message.from.id, database)
        wait_answer = command.give_answer(message.text)
        active_commands.push command if wait_answer > 0
      when '/reset'
        active_commands.clear
        command = Reset.new(bot, message.from.id, database)
        wait_answer = command.give_answer
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


# database struct
#
# user = {
#   subjects => {
#     mrz => {
#       labs_count => 10,
#       made_labs => [2,4,5,6]
#     }
#   },
#   start_date => '01-09-2016',
#   finish_date => '03-11-2016'
# }
