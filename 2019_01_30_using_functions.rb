# Welcome to Sonic Pi v3.1
define :chord_player do |syn_choice, root,
    change, n, spd|
  use_synth syn_choice
  n.times do
    play chord(root, change), release: rrand(0.3,1)
    sleep 1*spd
  end
end

define :appregio_player do |syn_choice,
    root, change, sleeper, n, spd|
  use_synth syn_choice
  n.times do
    play_pattern_timed chord(root, change),
      sleeper, release: rrand(0.3,1)
    sleep 1*spd
  end
end

define :scale_player do |syn_choice, root,
    change, oct, n, spd|
  use_synth syn_choice
  n.times do
    play_pattern_timed scale(root, change, num_octaves: oct),
      spd, release: rrand(0.3,1)
  end
end

define :riff_player do |syn_choice, root, change,
    oct, seed, n, spd|
  n.times do
    use_synth syn_choice
    #use_random_seed seed
    notes = (scale root, change, num_octaves: oct).shuffle
    play notes.tick, release: rrand(0.1,1),
      cutoff: rrand(50,100), res: rrand(0.85,1),
      wave: rrand_i(0,3)
    sleep 1*spd
  end
end

define :the_mix do |fx_one, fx_two, fx_three, n,
    syn_one, syn_two, syn_three, syn_four,
    tm_notes|
  
  speedy = rrand(0.01,0.75)
  
  with_fx fx_one do
    in_thread do
      n.times do
        riff_player syn_one,
          choose(tm_notes),
          choose([:major, :minor,
                  :major_pentatonic,
                  :minor_pentatonic]),
          5, 30, speedy*240, speedy
        chord_player syn_two,
          choose(tm_notes), choose([:major, :minor]),
          speedy*16, speedy
      end
    end
  end
  
  with_fx fx_two, phase: 2 do
    with_fx fx_three do
      n.times do
        appregio_player syn_three, choose(tm_notes),
          choose([:major, :minor]), 0.25, speedy*24, speedy
        scale_player syn_four, choose(tm_notes),
          choose([:major, :minor,
                  :major_pentatonic,
                  :minor_pentatonic]),
          2, speedy*16, speedy
      end
    end
  end
  
end

fx_list = [:band_eq, :whammy, :reverb, :bitcrusher, :slicer, :wobble,
           :compressor, :echo, :distortion, :flanger, :mono, :vowel,
           :gverb ]

s_list = [:beep, :blade, :bnoise, :chipbass, :chiplead, :chipnoise,
          :dark_ambience, :dpulse, :dsaw, :dtri, :dull_bell, :fm,
          :gnoise, :growl, :hollow, :hoover, :mod_beep, :mod_dsaw, :mod_fm,
          :mod_pulse, :mod_sine, :mod_saw, :mod_tri, :noise, :piano, :pluck,
          :pnoise, :pretty_bell, :prophet, :pulse, :saw, :sine, :sound_in,
          :sound_in_stereo, :square, :subpulse, :supersaw, :tb303, :zawa,
          :tech_saws, :tri]


use_random_seed 5130
the_mix choose(fx_list), choose(fx_list), choose(fx_list), 6,
  choose(s_list), choose(s_list), choose(s_list), choose(s_list),
  [:a1, :b2, :c3, :d1, :e2, :f3]
