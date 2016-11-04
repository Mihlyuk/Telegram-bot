class Command
  @@text = ''

  def initialize(dialog_step)
    @dialog_step = dialog_step
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