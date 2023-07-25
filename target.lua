function sysCall_init()
    objectToFollowPath=sim.getObject('.')
    path=sim.getObject('/Path')
    pathData=sim.unpackDoubleTable(sim.readCustomDataBlock(path,'PATH'))
    local m=Matrix(#pathData//7,7,pathData)
    pathPositions=m:slice(1,1,m:rows(),3):data()
    pathQuaternions=m:slice(1,4,m:rows(),7):data()
    pathLengths,totalLength=sim.getPathLengths(pathPositions,3)
    velocity=0.50 -- m/s
    posAlongPath=0
    previousSimulationTime=0
    corout=coroutine.create(coroutineMain)
end

function sysCall_actuation()
    if coroutine.status(corout)~='dead' then
        local ok,errorMsg=coroutine.resume(corout)
        if errorMsg then
            error(debug.traceback(corout,errorMsg),2)
        end
    end
end

function coroutineMain()
    sim.setThreadAutomaticSwitch(false)
    while true do
        local t=sim.getSimulationTime()
        posAlongPath=posAlongPath+velocity*(t-previousSimulationTime)
        posAlongPath=posAlongPath % totalLength
        local pos=sim.getPathInterpolatedConfig(pathPositions,pathLengths,posAlongPath)
        local quat=sim.getPathInterpolatedConfig(pathQuaternions,pathLengths,
                                                 posAlongPath,nil,{2,2,2,2})
        sim.setObjectPosition(objectToFollowPath,path,pos)
        sim.setObjectQuaternion(objectToFollowPath,path,quat)
        previousSimulationTime=t
        sim.switchThread()
    end
end