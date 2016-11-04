require 'telegram/bot'
require 'redis'
require 'json'

require_relative './commands/start.rb'
require_relative './commands/semester.rb'
require_relative './commands/subject.rb'
require_relative './commands/status.rb'
require_relative './commands/submit.rb'
require_relative './commands/reset.rb'
require_relative './commands/subject_remove.rb'

token = '282969345:AAEkW0070hAfVNlqKasIPvNYF076ANBSoMs'
database = Redis.new

default_commands = [Start, Semester, Subject, Status, Submit, Reset, Subject_remove]
active_commands = {}

puts database.ping
database.set('token', token)

DESC_COMMANDS = {
    '/start' => 'Выводит описание всех доступных команд',
    '/semester' => 'Запоминает даты начала и конца семестра',
    '/subject' => 'Добавляет предмет и количество лабораторных работ по нему',
    '/subject_remove' => 'Удаляет предмет',
    '/status' => 'Выводит твой список лаб, которые тебе предстоит сдать',
    '/submit' => 'Запоминает какие предметы ты сдал',
    '/reset' => 'Сбрасывает для пользователя все данные.'
}

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    user = message.from.id
    default_command = default_commands.find { |item| item.check_name(message.text) }
    command = nil

    if default_command
      active_commands[user] = nil





      command = default_command.new(bot, message.from.id, database)
    elsif active_commands[user]
      command = active_commands[user]
    end

    if command
      wait_answer = command.give_answer(message.text)
      active_commands[user] = command if wait_answer > 0
    end
  end
end

# database struct

# users = [
#     user_id => {
#         subjects => {
#             mrz => {
#                 labs_count => 10,
#                 made_labs => [2, 4, 5, 6]
#             }
#         },
#         start_date => '01-09-2016',
#         finish_date => '03-11-2016'
#     ],
#     token = 'ax123r123s13ies3n123esy123e'
# }
