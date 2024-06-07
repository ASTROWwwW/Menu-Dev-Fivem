-- server.lua

RegisterNetEvent('saveBlipToDB')
AddEventHandler('saveBlipToDB', function(name, type, size, color, display, shortRange, x, y, z)
    local src = source
    local shortRangeInt = shortRange and 1 or 0 -- Convert boolean to integer for SQL
    MySQL.Async.execute('INSERT INTO blips (name, type, size, color, display, short_range, x, y, z) VALUES (@name, @type, @size, @color, @display, @short_range, @x, @y, @z)', {
        ['@name'] = name,
        ['@type'] = type,
        ['@size'] = size,
        ['@color'] = color,
        ['@display'] = display,
        ['@short_range'] = shortRangeInt,
        ['@x'] = x,
        ['@y'] = y,
        ['@z'] = z
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('esx:showNotification', src, '~g~Blip enregistr� dans la base de donn�es.')
        else
            TriggerClientEvent('esx:showNotification', src, '~r~�chec de l\'enregistrement du blip.')
        end
    end)
end)
