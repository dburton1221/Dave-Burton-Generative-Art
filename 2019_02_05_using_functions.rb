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

define :the_control_mix do |fx_one, fx_two, fx_three, n,
    syn_one, syn_two, syn_three, syn_four, spd,
    tm_notes|
  with_fx fx_one do
    in_thread do
      n.times do
        #cue :tick if cutie == 1
        riff_player syn_one, choose(tm_notes), choose([:major, :minor, :major_pentatonic, :minor_pentatonic]), 5, 30, 30, spd
        chord_player syn_two, choose(tm_notes), choose([:major, :minor]), 3, spd
      end
    end
  end
  with_fx fx_two, phase: 2 do
    with_fx fx_three do
      n.times do
        #sync :tick if cutie == 1
        appregio_player syn_three, choose(tm_notes), choose([:major, :minor]), 0.25, 3, spd
        scale_player syn_four, choose(tm_notes), choose([:major, :minor, :major_pentatonic, :minor_pentatonic]), 2, 2, spd
      end
    end
  end
end

define :the_random_mix do |fx_one, fx_two, fx_three, n,
    syn_one, syn_two, syn_three, syn_four,
    tm_notes|
  speedy = rrand(0.01,0.5)
  with_fx fx_one do
    in_thread do
      n.times do
        riff_player syn_one,
          choose(tm_notes),
          choose([:major, :minor,
                  :major_pentatonic,
                  :minor_pentatonic]),
          5, 30, speedy*240, speedy
        scale_player syn_four, choose(tm_notes),
          choose([:major, :minor,
                  :major_pentatonic,
                  :minor_pentatonic]),
          2, speedy*16, speedy
      end
    end
  end
  with_fx fx_two, phase: 2 do
    with_fx fx_three do
      n.times do
        appregio_player syn_three, choose(tm_notes),
          choose([:major, :minor]), 0.25, speedy*24, speedy
        chord_player syn_two,
          choose(tm_notes), choose([:major, :minor]),
          speedy*16, speedy
      end
    end
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


define :intro do |spd, n|
  n.times do
    sample :bass_hit_c, amp: 3
    sleep 1*spd
  end
end

define :melody do |spd,n|
  n.times do
    l_bnd = choose([65,75,85])
    u_bnd = l_bnd+10
    n1 = rrand_i(l_bnd,u_bnd)
    n2 = n1 + 3
    n3 = n2 + 4
    ns1 = rrand_i(1,4)
    ns2 = ns1 + 1
    ns3 = ns2 + 1
    vol = 0.15
    use_synth :piano
    play n1, amp: vol*1, note_slide: ns1
    sleep 0.15*spd
    play n2, amp: vol*2, note_slide: ns2
    sleep 0.15*spd
    play n1, amp: vol*3, note_slide: ns1
    sleep 0.15*spd
    play n1, amp: vol*1, note_slide: ns1
    sleep 0.15*spd
    play n2, amp: vol*2, note_slide: ns2
    sleep 0.15*spd
    play n3, amp: vol*3, note_slide: ns3
    sleep 1*spd
  end
end

define :background do |spd, n|
  with_fx :reverb do
    in_thread do
      n.times do
        r=choose([0.25,0.5,1,1.5,2.0])
        5.times do
          sample :ambi_piano
          sleep 0.5*spd
        end
      end
    end
  end
  with_fx :wobble, phase: 5 do
    with_fx :echo, mix: 0.5 do
      n.times do
        sample :elec_triangle
        sample :bass_trance_c
        sleep 1*spd
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

use_random_seed 12849
the_random_mix choose(fx_list), choose(fx_list), choose(fx_list), rrand_i(2,3),
  choose(s_list), choose(s_list), choose(s_list), choose(s_list),
  [:a1, :b2, :c3, :d1, :e2, :f3, :g1]

use_random_seed 91352987
the_control_mix :flanger, :gverb, :bitcrusher, 3,
  :mod_saw, :chiplead, :dull_bell, :mod_beep,0.125,
  [:a1, :b1, :c1, :d1, :e1, :f1, :g1]

appregio_player :pretty_bell, :e2, :minor, 0.25, 2, 0.1
chord_player :dull_bell, :g3, :major, 3, 0.5

use_random_seed 128496301325
the_random_mix choose(fx_list), choose(fx_list), choose(fx_list), rrand_i(4,10),
  choose(s_list), choose(s_list), choose(s_list), choose(s_list),
  [:a1, :b2, :c3, :d1, :e2, :f3, :g1]

appregio_player :saw, :e2, :minor, 0.25, 2, 0.1
chord_player :saw, :d3, :major, 3, 0.5
riff_player :beep, :c1, :major_pentatonic, 2, 4, 2, 0.5
scale_player :mod_sine, :d1, :major_pentatonic, 2, 2, 0.1

