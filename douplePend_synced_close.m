function douplePend_synced_close(sim,clientID)
        % stop the simulation:
    sim.simxStopSimulation(clientID,sim.simx_opmode_blocking);

        % Now close the connection to CoppeliaSim:    
    sim.simxFinish(clientID);
    sim.delete(); % call the destructor!
    
    disp('Program ended');
end