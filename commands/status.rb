require_relative '../commands/command.rb'

class Status < Command

  def initialize(bot, user_id, database)
    @dialog_step = 1
    @bot = bot
    @user_id = user_id
    @database = database
  end

  def Status.check_name(text)
    text == '/status'
  end

  def give_answer(message)
    unless @database.hexists(@user_id, 'subjects')
      @bot.api.send_message(chat_id: @user_id, text: 'Жмакни кнопку /subject и задай лабы, которые нужно сдать)')
      return 0
    end

    unless @database.hexists(@user_id, 'start_date') && @database.hexists(@user_id, 'finish_date')
      @bot.api.send_message(chat_id: @user_id, text: 'Жмакни кнопку /semester и задай границы семестра')
      return 0
    end

    subjects = JSON.parse(@database.hget(@user_id, 'subjects'))

    #TODO: если subject == 0 просить ввести предметы

    start_date = Date.strptime(@database.hget(@user_id, 'start_date'), '%d-%m-%Y')
    finish_date = Date.strptime(@database.hget(@user_id, 'finish_date'), '%d-%m-%Y')
    date_now = Date.strptime(Time.now.strftime('%d-%m-%Y'), '%d-%m-%Y')

    available_time = (finish_date - start_date).to_i
    elapsed_time = (date_now - start_date).to_i

    answer = "К этому времени у тебя должно быть сдано: \n\n"

    subjects.each do |subject_name, subject|
      made_labs = JSON.parse(subject['made_labs'])
      labs_count = subject['labs_count']

      unmade_labs = []
      made_labs.each_with_index { |value, key| unmade_labs << key + 1 unless value }
      unmade_labs = unmade_labs.empty? ? "Лаб больше не осталось =(" : "Оставшиеся: #{unmade_labs}"

      made_labs_count = made_labs.count { |i| i } # Ох*@ть можно, как круто!!!
      need_made_labs = (labs_count * elapsed_time / available_time.to_f).ceil
      need_made_labs = 0 if need_made_labs < 0
      need_made_labs = labs_count if need_made_labs > labs_count

      statistic = "#{subject_name}\n   Должно быть сдано: #{need_made_labs}/#{labs_count}\n   Сдано: #{made_labs_count}/#{labs_count}\n   #{unmade_labs}\n\n"

      answer = answer + statistic
    end

    @bot.api.send_message(chat_id: @user_id, text: answer)

    @dialog_step = 0
  end

end