return function()
    local class = setmetatable({}, {
        __newindex = function(self, index, value)
            if index == '__table__' then
                rawset(self, index, value)
            else
                self.__table__[index] = value
                if _G.type(self.__table__[index .. '__set']) == 'function'
                then self.__table__[index .. '__set'](value) end
            end
        end,

        __index = function(self, index)
            if index == '__table__' then
                return rawget(self, index)
            else
                return self.__table__[index]
            end
        end
    }) class.__table__ = {} return class
end
