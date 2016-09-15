100.times do
  Runlog.create(run_count: "sample1", run_at: Time.now,
    temperature: rand(10.0..20.0).to_s,
    latitude: rand(35.5..36.0).to_s,
    longitude: rand(139.5..140.5).to_s)
  sleep(1)
end

100.times do
  Runlog.create(run_count: "sample2", run_at: Time.now,
    temperature: rand(20.0..30.0).to_s,
    latitude: rand(34.5..35.0).to_s,
    longitude: rand(137.5..138.5).to_s)
  sleep(1)
end
