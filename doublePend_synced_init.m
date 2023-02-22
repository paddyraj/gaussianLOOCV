function [sim,clientID] = doublePend_synced_init
    sim=remApi('remoteApi');
    sim.simxFinish(-1); % just in case, close all opened connections
    clientID=sim.simxStart('127.0.0.1',19997,true,true,5000,5); %might have to be 19999????
    if (clientID>-1)
        % enable the synchronous mode on the client:
        %sim.simxSynchronous(clientID,true);

        % start the simulation:
        %sim.simxStartSimulation(clientID,sim.simx_opmode_oneshot);
        disp('you have initialized the Sim. PLEASE DO NOT clear your workspace.')
    else
        disp('you did not connect to the sim. please try again.')
    end 
end