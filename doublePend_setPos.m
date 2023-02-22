function doublePedn_setPos(theta,sim,clientID)

    if (clientID>-1)
        
        [returnCode,Joint1]=sim.simxGetObjectHandle(clientID,'Joint1',sim.simx_opmode_blocking);
        [returnCode,Joint2]=sim.simxGetObjectHandle(clientID,'Joint2',sim.simx_opmode_blocking);
        
        [returnCode]=sim.simxSetJointPosition(clientID,Joint1,theta(1),sim.simx_opmode_blocking);
        [returnCode]=sim.simxSetJointPosition(clientID,Joint2,theta(2),sim.simx_opmode_blocking);
        sim.simxSynchronousTrigger(clientID);
 
    else
        disp('Failed connecting to remote API server');
    end

end