--[[
The logger helper prototype.

Provides helper methods to log and debug.

@since 1.0.0
]]
MemoryAddon_LoggerHelper = {};
MemoryAddon_LoggerHelper.__index = MemoryAddon_LoggerHelper;

--[[
Constructs a new instance of a logger helper.

@since 1.0.0

@return MemoryAddon_LoggerHelper
]]
function MemoryAddon_LoggerHelper:new()

  local instance = {};
  setmetatable( instance, MemoryAddon_LoggerHelper );

  instance.LEVEL_DEBUG =  0;
  instance.LEVEL_INFO  = 10;
  instance.LEVEL_WARN  = 20;
  instance.LEVEL_ERROR = 30;
  instance.LEVEL_OFF   = 40;

  -- current log level
  instance.logLevel = instance.LEVEL_WARN;


  --[[
  Prints a debug message.

  @since 1.0.0

  @param string message the message to log
  ]]
  function instance:debug( message )

    self:log( message, self.LEVEL_DEBUG );
  end


  --[[
  Prints an error message.

  @since 1.0.0

  @param string message the message to log
  ]]
  function instance:error( message )

    self:log( message, self.LEVEL_ERROR );
  end


  --[[
  Prints an info message.

  @since 1.0.0

  @param string message the message to log
  ]]
  function instance:info( message )

    self:log( message, self.LEVEL_INFO );
  end


  --[[
  Prints a log message if the log level is greater than the current log level set.

  @since 1.0.0

  @param string message the message to log
  @param int level the min log level required to print the message
  ]]
  function instance:log( message, level )

    if level >= self.logLevel then

      local prefix = MemoryCore:highlight( '<' .. MemoryCore.ADDON_NAME .. ' Debug' .. '>' );

      MemoryCore:print( message, prefix );
    end
  end


  --[[
  Prints a warn message.

  @since 1.0.0

  @param string message the message to log
  ]]
  function instance:warn( message )

    self:log( message, self.LEVEL_WARN );
  end


  -- destroys the prototype, so instance will be unique
  MemoryAddon_LoggerHelper = nil;

  return instance;
end
