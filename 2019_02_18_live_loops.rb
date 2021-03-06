# Welcome to Sonic Pi v3.1
define :chord_player do |syn_choice, root,
    change, n, spd|
  use_synth syn_choice
  n.times do
    play chord(root, change), release: rrand(0.3,1), amp: 2
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

define :melody do |spd,n, s_choice|
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
    use_synth s_choice
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

define :melody_two do |spd,n, s_choice1, s_choice2|
  in_thread do
    melody spd, n, s_choice1
  end
  melody spd, n, s_choice2
end

define :melody_three do |spd,n, s_choice1, s_choice2,
    s_choice3|
  in_thread do
    melody spd, n, s_choice3
  end
  in_thread do
    melody spd, n, s_choice1
  end
  melody spd, n, s_choice2
end

define :melody_four do |spd,n, s_choice1, s_choice2,
    s_choice3, s_choice4|
  in_thread do
    melody spd, n, s_choice3
  end
  in_thread do
    melody spd, n, s_choice2
  end
  in_thread do
    melody spd, n, s_choice1
  end
  melody spd, n, s_choice4
end

define :melody_five do |spd,n, s_choice1, s_choice2,
    s_choice3, s_choice4, s_choice5|
  in_thread do
    melody spd, n, s_choice4
  end
  in_thread do
    melody spd, n, s_choice3
  end
  in_thread do
    melody spd, n, s_choice2
  end
  in_thread do
    melody spd, n, s_choice1
  end
  melody spd, n, s_choice5
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

#play with all the tools you have made now,
#but play with live loops or threads this time

live_loop :background do
  use_synth :mod_beep
  notes = (scale :a2, :minor, num_octaves: 2)
  notes.shuffle
  play notes.tick
  sleep 0.5
end

live_loop :chords do
  chord_player :beep, :d1, :major, 1, 0.25
  sleep 0.5
  chord_player :beep, :a1, :minor, 1, 0.25
  sleep 0.5
  chord_player :beep, :g1, :major, 1, 0.25
  sleep 0.5
end

live_loop :appregios do
  appregio_player :pretty_bell, :f2, :minor, 0.25, 1, 0.25
  sleep 0.5
  appregio_player :pretty_bell, :g3, :major, 0.25, 1, 0.25
  sleep 0.5
  appregio_player :pretty_bell, :b2, :major, 0.25, 1, 0.25
  sleep 0.5
end

live_loop :riffs do
  riff_player :mod_tri, :b1, :major_pentatonic, 3, 3, 1, 0.25
  sleep 0.5
  riff_player :mod_tri, :g1, :major_pentatonic, 3, 3, 1, 0.25
  sleep 0.5
  riff_player :mod_tri, :c1, :major_pentatonic, 3, 3, 1, 0.25
  sleep 0.5
end



