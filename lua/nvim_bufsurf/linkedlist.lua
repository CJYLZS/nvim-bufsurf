-- a simple linked list

-- Node structure
local Node = {
    value = nil,
    next = nil,
    prev = nil,
}

-- Linked list structure
local LinkedList = {
    head = nil,
    tail = nil,
    cur = nil,
    cur_pos = 0,
    length = 0,
    max_length = 50,
}

-- Insert a value at the end of the linked list
function LinkedList:insert(value)
    local newNode = { value = value, next = nil, prev = nil }

    if not self.head then
        self.head = newNode
        self.tail = newNode
    elseif value == self.tail.value then
        -- do not add duplicate node after tail
        return
    else
        if self.cur ~= self.tail then
            -- before add a newNode, delete all node(s) after cur, update self.length
            self.cur.next = nil
            self.length = self.cur_pos + 1
            self.tail = self.cur
        end
        self.tail.next = newNode
        newNode.prev = self.tail
        self.tail = newNode
    end

    self.length = self.length + 1
    if self.length > self.max_length then
        -- keep LinkedList length <= max_length
        self.head = self.head.next
        self.head.prev = nil
        self.length = self.max_length
    end

    -- update cur and cur_pos
    self.cur = self.tail
    self.cur_pos = self.length - 1
end

function LinkedList:forward()
    local ret = nil
    if self.cur and self.cur.next then
        self.cur = self.cur.next
        self.cur_pos = self.cur_pos + 1
        ret = self.cur.value
    end
    return ret
end

function LinkedList:backward()
    local ret = nil
    if self.cur and self.cur.prev then
        self.cur = self.cur.prev
        self.cur_pos = self.cur_pos - 1
        ret = self.cur.value
    end
    return ret
end

return LinkedList
