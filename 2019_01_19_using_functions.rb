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

define :the_mix do |fx_one, fx_two, fx_three, n,
    syn_one, syn_two, syn_three, syn_four,
    tm_notes|
  
  with_fx fx_one do
    in_thread do
      n.times do
        riff_player syn_one, choose(tm_notes), choose([:major, :minor, :major_pentatonic, :minor_pentatonic]), 5, 30, 30, 0.125
        chord_player syn_two, choose(tm_notes), choose([:major, :minor]), 3, 0.125
      end
    end
  end
  
  with_fx fx_two, phase: 2 do
    with_fx fx_three do
      n.times do
        appregio_player syn_three, choose(tm_notes), choose([:major, :minor]), 0.25, 3, 0.125
        scale_player syn_four, choose(tm_notes), choose([:major, :minor, :major_pentatonic, :minor_pentatonic]), 2, 2, 0.125
      end
    end
  end
  
end

the_mix :reverb, :whammy, :bitcrusher, 6,
  :prophet, :dsaw, :piano, :hollow,
  [:a1, :b1, :c1, :d1, :e1, :f1, :g1]

the_mix :slicer, :whammy, :wobble, 6,
  :dark_ambience, :piano, :pluck, :dsaw,
  [:e3, :c3, :g3]

the_mix :slicer, :whammy, :wobble, 6,
  :dark_ambience, :piano, :pluck, :dsaw,
  [:e3, :c3, :g3, :b1, :c1, :c2]
