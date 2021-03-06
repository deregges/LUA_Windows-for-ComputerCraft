local p = {}
local function checkValid(j,e)
  return true
  end
local function processEvent(e)
  result = {}
  for i,j in pairs(p) do
    if checkValid(j,e) then
      table.insert(result,i,e)
      end
    end
  return result
  end

function resumeProcess(j,evt)
  if (j.f == nil or j.f == evt[1] or evt[1] == "terminate") then
    if j.screen then term.redirect(j.screen) end
    local ok,data = coroutine.resume(j.p,unpack(evt))
    if ok then j.f = data else if j.onError then j.onError(PID,data) end end
    if coroutine.status(j.p)=="dead" then if j.onTerminate then j.onTerminate(PID) end terminate(PID) end
    end
  end
function stop()
  term.redirect(term.native())
  term.setBackgroundColor(colors.black)
  term.setTextColor(colors.white)
  term.clear()
  term.setCursorPos(1,1)
  error()
  end
function getProcesses()
  return p
  end
function terminate(PID)
  p[PID] = nil
  end
function insert_processEvent(data)
  processEvent = data
  insert_processEvent = nil
  end
function insert_checkValid(data)
  checkValid = data
  insert_checkValid = nil
  end
function start()
  local e = {}
  while true do
    for PID,evt in pairs(processEvent(e)) do
      resumeProcess(p[PID],evt)
      end
    e = {os.pullEventRaw()}
    cclite.message(e[1])
    end
  end
function create(func,data)
  local new = {}
  new.p = coroutine.create(func)
  new.f = nil
  --> onTerminate()
  --> onError(err)
  --> screen
  for i,j in pairs(data) do new[i] = j end
  table.insert(p,new)
  return #p
  end