with_fx :reverb do
  in_thread do
    loop do
      sample :bd_zum, rate: (rrand 0.25, 1.5)
      sleep 0.5
    end
  end
end

with_fx :wobble, phase: 3 do
  with_fx :echo, mix: 0.7 do
    loop do
      sample :bass_hit_c
      sleep 1
    end
  end
end