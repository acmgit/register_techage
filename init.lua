-- Registers nodes foreign Nodes for techage with tubes ...

function register_tube(node, pull_inventory, push_inventory)
    local push_inventory = push_inventory or pull_inventory
    local OwnerCache = {}

    -- Check if the chest is in the protected area of the owner
    local function is_owner(pos, meta)
        local owner = meta:get_string("owner")
        local key = minetest.hash_node_position(pos)
        -- If successfull, store info in cache
        if OwnerCache[key] ~= owner then
            if not minetest.is_protected(pos, owner) then
                OwnerCache[key] = owner
            end
        end
        return OwnerCache[key] == owner
    end

    techage.register_node({node}, {
        on_inv_request = function(pos, in_dir, access_type)
            local meta = minetest.get_meta(pos)
            return meta:get_inventory(), pull_inventory
        end,
        on_pull_item = function(pos, in_dir, num)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            return techage.get_items(pos, inv, pull_inventory, num)
        end,
        on_push_item = function(pos, in_dir, stack)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            return techage.put_items(inv, push_inventory, stack)
        end,
        on_unpull_item = function(pos, in_dir, stack)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            return techage.put_items(inv, pull_inventory, stack)
        end,
    })

end

if(minetest.get_modpath("smartshop")) then
    register_tube("smartshop:wifistorage", "main")
    register_tube("smartshop:shop", "main")

end


if(minetest.get_modpath("currency")) then
    register_tube("currency:shop", "customers_gave", "stock")

end
