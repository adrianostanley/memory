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
  Checks if a full memory path is set.

  A full memory path is where all the player memories about a thing are stored.

  If this is the first time of a player in a realm, the full memory path will be
  created with the interaction type.

  @since 0.2.0-alpha

  @param string category
  @param string[] path
  @param string interaction_type
  ]]
  function instance:check( category, path, interaction_type )

    -- creates a pointer to the current path in the memory array
    local memoryDataSetAux = MemoryDataSet[ self.realm ][ self.player ][ category ];

    for i = 1, #path, 1 do

      if memoryDataSetAux[ path[ i ] ] == nil then

        -- initializes the current path
        memoryDataSetAux[ path[ i ] ] = {};
      end

      -- sets the current path index in the pointer
      memoryDataSetAux = memoryDataSetAux[ path[ i ] ];
    end

    if memoryDataSetAux[ interaction_type ] == nil then

      -- initializes the memory interaction type
      memoryDataSetAux[ interaction_type ] = {};

      -- initializes the first time player experienced this memory
      memoryDataSetAux[ interaction_type ]["first"] = -1;

      -- initializes the last time player experienced this memory
      memoryDataSetAux[ interaction_type ]["last"] = -1;

      -- initializes the number of times player experienced this memory
      memoryDataSetAux[ interaction_type ]["x"] = 0;
    end

    -- returns the current pointer to ease on the store method
    return memoryDataSetAux[ interaction_type ];
  end


  --[[
  Checks if the player memories are already initialized.

  If this is the first time of a player in a realm, it will be created as an
  empty array along with the player's memories about npcs, players, zones, etc.

  @since 0.2.0-alpha
  ]]
  function instance:checkMyself()

    self:checkRealm();

    if MemoryDataSet[ self.realm ][ self.player ] == nil then

      -- initializes the player memory
      MemoryDataSet[ self.realm ][ self.player ] = {};

      -- initializes the miscellaneous memories, mainly for admin purposes
      MemoryDataSet[ self.realm ][ self.player ]["misc"] = {};

      -- initializes the player memories about npcs
      MemoryDataSet[ self.realm ][ self.player ]["npcs"] = {};

      -- initializes the player memories about other players
      MemoryDataSet[ self.realm ][ self.player ]["players"] = {};

      -- initializes the player memories about zones
      MemoryDataSet[ self.realm ][ self.player ]["zones"] = {};

      -- initializes the player memories about items
      MemoryDataSet[ self.realm ][ self.player ]["items"] = {};
    end
  end


  --[[
  Checks if the current realm is already initialized in memory.

  If this is the first time of a player in a realm, it will be created as an
  empty array.

  @since 0.2.0-alpha
  ]]
  function instance:checkRealm()

    if MemoryDataSet[ self.realm ] == nil then

      MemoryDataSet[ self.realm ] = {}
    end
  end


  --[[
  Crafts a memory string used to store important data to a player memory.

  @since 0.2.0-alpha

  @return string
  ]]
  function instance:craftMemoryString()

    -- gets the memory string data values
    local currentDate = date( "%y-%m-%d" );
    local playerLevel = UnitLevel( "player" );
    local zoneName    = GetZoneText();
    local subZoneName = GetSubZoneText();

    -- replaces nil values with a slash
    if currentDate == nil then currentDate = '-' end
    if playerLevel == nil or playerLevel == 0  then playerLevel = '-' end
    if zoneName    == nil or zoneName    == "" then zoneName    = '-' end
    if subZoneName == nil or subZoneName == "" then subZoneName = '-' end

    -- crafts and returns the memory string
    return currentDate .. "|" .. playerLevel .. "|" .. zoneName .. "|" .. subZoneName;
  end


  --[[
  Stores a player's memory.

  @since 0.2.0-alpha

  @param string category
  @param string[] path
  @param string interaction_type
  @param int x (optional)
  ]]
  function instance:store( category, path, interaction_type, --[[optional]] x )

    -- sets the default value for x if not defined
    x = x or 1;

    -- makes sure the full memory path is already set
    local memoryPath = self:check( category, path, interaction_type );

    -- gets the memory string to store the player's memory
    local memoryString = self:craftMemoryString();

    -- stores the first time player experienced this memory
    if memoryPath["first"] == -1 then memoryPath["first"] = memoryString; end

    -- stores the last time player experienced this memory
    memoryPath["last"] = memoryString;

    -- increases the number of times player experienced this memory
    memoryPath["x"] = memoryPath["x"] + x;

    -- just a debug message to... help us debug!
    MemoryCore:debug( "A '" .. interaction_type .. "' memory was stored for '" .. category .."' (" .. memoryString .. ")" );
  end


  --[[
  Determines whether the memory data set is set.

  @since 0.2.0-alpha

  @return bool
  ]]
  function instance:testConnection()

    return MemoryDataSet ~= nil;
  end

  -- may initialize the player's memories
  instance:checkMyself();

  -- destroys the prototype, so instance will be unique
  MemoryRepository:destroyPrototype();

  return instance;
end


--[[
Destroys the MemoryRepository prototype to prevent it from being initialized again.

This is the closest thing to a singleton I could come with so far.

@since 0.4.0-alpha
]]
function MemoryRepository:destroyPrototype()

  MemoryRepository = nil;
end
