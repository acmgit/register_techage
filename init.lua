-- Registers nodes foreign Nodes for techage with tubes ...

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


if(minetest.get_modpath("smartshop")) then
    techage.register_node({"smartshop:wifistorage"}, {
        on_inv_request = function(pos, in_dir, access_type)
            local meta = minetest.get_meta(pos)
            if is_owner(pos, meta) then
                return meta:get_inventory(), "main"
            end
        end,
        on_pull_item = function(pos, in_dir, num)
            local meta = minetest.get_meta(pos)
            if is_owner(pos, meta) then
                local inv = meta:get_inventory()
                return techage.get_items(pos, inv, "main", num)
            end
        end,
        on_push_item = function(pos, in_dir, stack)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            return techage.put_items(inv, "main", stack)
        end,
        on_unpull_item = function(pos, in_dir, stack)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            return techage.put_items(inv, "main", stack)
        end,
    })

end
