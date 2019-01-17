define :intro do |sam_1, sam_2, sam_3, spd|
  3.times do
    sample sam_1
    sleep 1*spd
  end
  in_thread do
    3.times do
      sample sam_1, amp: 0.25
      sleep 1*spd
    end
  end
  3.times do
    sample sam_2, amp: 3
    sleep 1*spd
  end
  in_thread do
    3.times do
      sample sam_1, amp: 0.25
      sleep 1*spd
    end
  end
  in_thread do
    3.times do
      sample sam_2, amp: 3
      sleep 1*spd
    end
  end
  counter=1
  3.times do
    sample sam_3, attack: 0.25, attack_level: 0.25, sustain: 0.5,sustain_level: 0.5, decay: 0.25, decay_level: 0.15
    sleep 1*spd
    counter += 1
  end
end

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

define :random_chords do
  syn = choose([:piano, :tb303, :pluck])
  note_choice = choose([:e3, :g3, :c3])
  the_change = choose([:minor, :major])
  
  3.times do
    use_synth syn
    play chord(note_choice, the_change), release: 0.3
    sleep 1
  end
end

random_chords
intro :drum_cymbal_open, :drum_heavy_kick, :drum_roll, 1
chord_player :piano, :e3, :minor, 3, 0.5
appregio_player :piano, :e3, :minor, 0.25, 3, 0.5
chord_player :piano, :e3, :major, 3, 0.5
appregio_player :piano, :e3, :major, 0.25, 3, 0.5
chord_player :piano, :g3, :minor, 3, 0.5
appregio_player :piano, :g3, :minor, 0.25, 3, 0.5
scale_player :piano, :c3, :major_pentatonic, 2, 2, 0.5
random_chords