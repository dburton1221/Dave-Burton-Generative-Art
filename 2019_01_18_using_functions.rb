define :chord_player do |syn_choice, root, change, n, spd|
  use_synth syn_choice
  n.times do
    play chord(root, change), release: 0.3
    sleep 1*spd
  end
end

define :appregio_player do |syn_choice, root, change, sleeper, n, spd|
  use_synth syn_choice
  n.times do
    play_pattern_timed chord(root, change), sleeper, release: 0.3
    sleep 1*spd
  end
end

define :scale_player do |syn_choice, root, change, oct, n, spd|
  use_synth syn_choice
  n.times do
    play_pattern_timed scale(root, change, num_octaves: oct), spd, release: 0.3
  end
end

define :riff_player do |syn_choice, root, change, oct, seed, n, spd|
  n.times do
    use_synth syn_choice
    use_random_seed seed
    notes = (scale root, change, num_octaves: oct).shuffle
    play notes.tick, release: 0.3, cutoff: 100, res: 0.85, wave: 1
    sleep 1*spd
  end
end

#TODO, perhaps make a few more players
#TODO, and perhaps make some mixers with effects

#TODO, find a way to make a tool that does this mixing
#of your players and accepts various inputs

with_fx :reverb do
  in_thread do
    loop do
      riff_player :piano, :e3, :major, 5, 30, 30, 0.125
      chord_player :piano, :e3, :minor, 3, 0.125
    end
  end
end

with_fx :wobble, phase: 2 do
  with_fx :echo do
    loop do
      appregio_player :piano, :e3, :minor, 0.25, 3, 0.125
      scale_player :piano, :e3, :major, 2, 2, 0.125
    end
  end
end


