# Welcome to Sonic Pi v3.1
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
    vol = 0.15
    use_synth :piano
    play n1, amp: vol*1, note_slide: 1
    sleep 0.15*spd
    play n2, amp: vol*2, note_slide: 1
    sleep 0.15*spd
    play n1, amp: vol*3, note_slide: 1
    sleep 0.15*spd
    play n1, amp: vol*1, note_slide: 1
    sleep 0.15*spd
    play n2, amp: vol*2, note_slide: 1
    sleep 0.15*spd
    play n3, amp: vol*3, note_slide: 1
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


intro 1, 3
melody 0.75, 3
background 1, 20




