local unzip = require("unzip")

local z, err = unzip.open(path)
if z then
    for fn in z:files() do
        printf('file: %s', fn.filename)
        if fn.filename == 'test.txt' then
            local s = z:read('*a') -- read all
            printf('> test.txt: %s', s)
            break
        end
    end
else
    printf('err = %s', err)
end