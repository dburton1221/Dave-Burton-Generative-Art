define :intro do |spd, n|
  n.times do
    sample :bass_hit_c, amp: 3
    sleep spd
  end
end

define :melody do |spd|
  l_bnd = choose([65,75,85])
  u_bnd = l_bnd+10
  n1 = rrand_i(l_bnd,u_bnd)
  n2 = n1 + 3
  n3 = n2 + 4
  vol = 0.15
  play n1, amp: vol*1
  sleep spd
  play n2, amp: vol*2
  sleep spd
  play n3, amp: vol*3
  sleep 0.1+spd*6
end

define :build_up do |spd, n|
  n.times do
    sample :bass_hit_c, amp: 3
    sleep spd
    with_fx :slicer do
      melody spd
    end
  end
end

define :open_skies do |spd, n|
  with_fx :wobble, mix: 0.5, reps:n do
    sample :ambi_swoosh
    sample :elec_chime
    melody spd
    sleep spd
  end
end

counter = 0
3.times do
  rate = 1/(counter+1)
  rate_div = counter*0.05
  rpts = counter + 1
  intro rate, 3*rpts
  build_up 0.15-rate_div, 5*rpts
  open_skies 0.25-rate_div, 5*rpts
  counter = counter +1
end

counter = 0
3.times do
  rpts = counter + 1
  with_fx :echo do
    intro 1/(counter+1), 5*rpts
  end
  counter = counter + 1
end


