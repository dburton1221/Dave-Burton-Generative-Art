# Welcome to Sonic Pi v3.1
live_loop :bass do
  sample :bass_hit_c, attack: 0.5, attack_level: 3, sustain: 0.25, sustain_level: 1, release: 0.5
  sleep 0.5
end
live_loop :long_theme do
  sample :ambi_soft_buzz, amp: 6, rate: 0.5
  sleep 5
end
live_loop :melody do
  use_synth :dark_ambience
  play 65
  sleep 1
  play 68
  sleep 1
  play 71
  sleep 2
end
