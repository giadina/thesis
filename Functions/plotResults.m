function plotResults( numberOfStates,distanceVector,estimateVectorStates,intersection_interval_UP, intersection_interval_DWN,confidenceArrayStates)
%PLot results in different figures for each state
%DA INSERIRE NELLA FUNZIONE,confidenceArrayStates2,intersection_interval_UP2, intersection_interval_DWN2,tEnd,tStart

total = numberOfStates*numberOfStates;
% flippedUP(:,:,:) = flipud(intersection_interval_UP2(:,:,:));
% flippedDWN(:,:,:) = flipud(intersection_interval_DWN2(:,:,:));

figure(100)
plot(distanceVector)

for state=1:total
    figure(state)
    plot(estimateVectorStates(:,:,state),'k-')
    hold on
        for i=1:size(intersection_interval_UP,1)
            line([i i], [intersection_interval_UP(i,1,state) intersection_interval_DWN(i,1,state)], 'Color', [1,0,0])
            hold on
        end
%         for ii=1:size(intersection_interval_UP2,1)
%             line([ii ii], [flippedUP(ii,1,state) flippedDWN(ii,1,state)], 'Color', [0,0,1])
%             hold on
%         end
    
%     line([tEnd(state) tEnd(state)],ylim,'LineWidth',2,'Color', 'r')
%     line([tStart(state) tStart(state)],ylim,'LineWidth',2,'Color', 'b')
%     hold on 
    plot(confidenceArrayStates(:,:,state),'k:','Color','k')
%     hold on
%     plot(confidenceArrayStates2(end:-1:1,:,state),'k:','Color','g')
    title(['State' num2str(floor(((state-1)/numberOfStates)+1)) '-' num2str(mod(state-1, numberOfStates) + 1)])
    hold off
end


%[distanceVector2] = computeDistance2(myArray);
%figure(7)
%plot(distanceVector2)

%estimateVector = permute(estimatePij,[1 3 2]);
%estimateVector = reshape(estimateVector,[],size(estimatePij,2),1);
%estimateVector = reshape(estimateVector.',[],1);

%figure(3)
%plot(estimateVector,'k-')
%hold on
%plot(confidence,'k:')
%hold off
end

