local SharedConfig = require 'config_shared'

local module_to_load = 'standalone'

for k, v in pairs(SharedConfig.frameworks) do
  if GetResourceState(v) ~= 'missing' then
    if k == 'qb' then
      if GetResourceState('qbx_core') ~= 'missing' then
        module_to_load = 'qbx'
        break
      end
    end
    module_to_load = k
    break
  end
end

local module = ('bridge.%s.%s'):format(module_to_load, IsDuplicityVersion() and 'server' or 'client')
return require(module)