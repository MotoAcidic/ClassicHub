if not NodeExists() and PlayerPosition(-9200.8115234375, -4163.1162109375, 12.647930145264) then
    UnstuckTo(-9192.390625, -4165.5454101563, 11.921274185181) StartUnstuckRoute()
end
if not NodeExists() and IsUnstuckRequired() and PlayerPosition(-9192.390625, -4165.5454101563, 11.921274185181) then
    UnstuckTo(-9186.1572265625, -4171.9228515625, 15.957651138306)
end
if not NodeExists() and IsUnstuckRequired() and PlayerPosition(-9186.1572265625, -4171.9228515625, 15.957651138306) then
    UnstuckTo(-9181.4189453125, -4179.3579101563, 18.348360061646) EndUnstuckRoute()
end

