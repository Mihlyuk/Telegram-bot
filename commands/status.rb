class Status
  def initialize(bot, user_id, database)
    @dialog_step = 1
    @bot = bot
    @user_id = user_id
    @database = database
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
      unmade_labs = unmade_labs.size == 0 ? "Лаб больше не осталось =(" : "Оставшиеся: #{unmade_labs}"

      made_labs_count = made_labs.count { |i| i } # Ох*@ть можно, как круто!!!
      need_made_labs = (labs_count * elapsed_time / available_time.to_f).ceil

      statistic = "#{subject_name}\n   Должно быть сдано: #{need_made_labs}/#{labs_count}\n   Сдано: #{made_labs_count}/#{labs_count}\n   #{unmade_labs}\n\n"

      answer = answer + statistic
    end

    @bot.api.send_message(chat_id: @user_id, text: answer)

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