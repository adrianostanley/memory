--[[
The main slash command for the Memory Addon.

The slash command structure for /memoryaddon is: command key value, where command
is the command to be executed by Memory Addon, key is the first argument and value
is the second argument that will get the command tail, regardless of spaces in it.

Example: /memoryaddon set myname My name is Squareone
  Command: set
  Key: myname
  Value: My name is Squareone

@since 1.0.0
]]
SLASH_MEMORYADDON1 = '/memoryaddon'
SlashCmdList['MEMORYADDON'] = function( arg )

  -- sanity check
  if nil == arg then MemoryCore:print( 'Invalid command' ); return; end

  -- helps parsing the slash command arguments
  local argumentIndex = 1;

  local argumentCommand = nil;
  local argumentKey     = nil;
  local argumentValue   = nil;

  for argument in arg:gmatch( '%S+' ) do

    -- parses each command part
        if 1 == argumentIndex then argumentCommand = argument;
    elseif 2 == argumentIndex then argumentKey     = argument;
    elseif 3 == argumentIndex then argumentValue   = argument;
    else                           argumentValue   = argumentValue .. ' ' .. argument;
    end

    -- increments the argument index
    argumentIndex = argumentIndex + 1;
  end

  -- settings command
  if 'set' == argumentCommand then

    -- sanity check
    if nil == argumentKey then MemoryCore:print( 'Invalid setting key for the set command' ); return; end

    -- prints a setting value
    if nil == argumentValue then

      -- gets the setting
      local setting = MemoryCore:setting( argumentKey );

      if nil ~= setting then

        MemoryCore:print(argumentKey .. '=' .. setting);
      else

        MemoryCore:print( 'No setting with key = ' .. argumentKey .. ' was found' );
      end

      -- returns after command execution
      return;
    end

    -- sets the setting value
    local setting = MemoryCore:setting( argumentKey, argumentValue, true );

    -- confirmation to user
    MemoryCore:print( argumentKey .. ' set to ' .. argumentValue );

    -- returns after command execution
    return;
  elseif 'add' == argumentCommand then

    -- sanity check
    if nil == argumentKey then MemoryCore:print( 'Invalid key for the add command' ); return; end

    -- prints a setting value
    if nil == argumentValue then MemoryCore:print( 'Invalid value for the add command' ); return; end

    if 'moment' == argumentKey then

      -- adds a moment
      MemoryCore:getMomentRepository():addMoment( argumentValue );

      -- confirmation to user
      MemoryCore:print( 'Current moment updated' );
    else

      MemoryCore:print( 'Invalid key (' .. argumentKey .. ') for the add command' );
    end

    -- returns after command execution
    return;
  elseif 'get' == argumentCommand then

    -- sanity check
    if nil == argumentKey then MemoryCore:print( 'Invalid key for the get command' ); return; end

    if 'moment' == argumentKey then

      MemoryCore:print( MemoryCore:getMomentRepository():getCurrentMoment() );
    else

      MemoryCore:print( 'Invalid key (' .. argumentKey .. ') for the get command' );
    end

    return;
  end -- settings command

  -- if got here, it's because no command was executed
  MemoryCore:print( 'Invalid command: ' .. argumentCommand );
end
