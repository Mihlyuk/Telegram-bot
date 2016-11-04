require 'redis'
require 'curl'
require 'json'
require 'cgi'

db = Redis.new
curl = CURL.new

token = db.get('token')
user_id = db.get('users')

subjects = JSON.parse(db.hget(user_id, 'subjects'))

if subjects.keys.length > 0
  start_date = Date.strptime(db.hget(user_id, 'start_date'), '%d-%m-%Y')
  finish_date = Date.strptime(db.hget(user_id, 'finish_date'), '%d-%m-%Y')
  date_now = Date.strptime(Time.now.strftime('%d-%m-%Y'), '%d-%m-%Y')

  available_time = (finish_date - start_date).to_i
  elapsed_time = (date_now - start_date).to_i

  answer = "К этому времени у тебя должно быть сдано: \n\n"

  subjects.each do |subject_name, subject|
    made_labs = JSON.parse(subject['made_labs'])
    labs_count = subject['labs_count']

    unmade_labs = []
    made_labs.each_with_index { |value, key| unmade_labs << key + 1 unless value }
    unmade_labs = unmade_labs.empty? ? 'Лаб больше не осталось =(' : "Оставшиеся: #{unmade_labs}"

    made_labs_count = made_labs.count { |i| i }
    need_made_labs = (labs_count * elapsed_time / available_time.to_f).ceil
    need_made_labs = 0 if need_made_labs < 0
    need_made_labs = labs_count if need_made_labs > labs_count

    statistic = "#{subject_name}\n   Должно быть сдано: #{need_made_labs}/#{labs_count}\n   Сдано: #{made_labs_count}/#{labs_count}\n   #{unmade_labs}\n\n"

    answer = answer + statistic
  end

  curl.get("https://api.telegram.org/bot#{token}/sendMessage?chat_id=#{user_id}&text=#{CGI.escape(answer)}")

end
