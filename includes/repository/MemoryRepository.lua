--[[
The repository prototype.

Provides all read and write methods to manipulate the player memory.

@since 0.2.0-alpha
]]
MemoryRepository = {};
MemoryRepository.__index = MemoryRepository;

--[[
Constructs a new instance of a memory repository.

@since 0.2.0-alpha

@param string realm
@param string player
@returns MemoryRepository
]]
function MemoryRepository:new( player, realm )

  local instance = {};
  setmetatable( instance, MemoryRepository );
  instance.player = player;
  instance.realm = realm;


  --[[
  Crafts a memory string used to store important data to a player memory.

  @since 0.2.0-alpha

  @return string
  ]]
  function instance:craftMemoryString()

  end


  --[[
  Determines whether the memory data set is set.

  @since 0.2.0-alpha

  @return bool
  ]]
  function instance:testConnection()

    return MemoryDataSet ~= nil;
  end

  return instance;
end