function Nclust = cluster_detection(linkagetree, similarity, testmethod, fig)
%to be written


if nargin <4 | isempty(fig)
    mainfigure = 0;
else
    mainfigure = 1;
end

distance = 1 - similarity;

default_groups = 2:30;

counter = 1;
for igroup = default_groups
    CL = cluster(linkagetree,'maxclust',igroup);
    maxCL = max(CL);
    
    switch testmethod
        case 'dunn'
            idx(counter) = local_dunn_test(CL, distance);
        case 'davies'
            idx(counter) = local_davies_test(CL, similarity);
    end
    counter = counter+1;
end

[~,id] = find(diff(idx)>0,1,'first');
if isempty(id) || id==length(default_groups)-1
    % The indices are decreasing, so select the first
    recommended = default_groups(1);
    id = 1;
else
    % Find the first peak of the indices
    indicesCopy = idx;
    indicesCopy(1:id) = 0;
    [~,id] = find(diff(indicesCopy)<0,1,'first');
    if isempty(id)
        % If there is no peak find the first sudden increase
        [~,id] = find(diff(diff(indicesCopy))<0,1,'first');
        id = id+1;
    end
    recommended = default_groups(id);
end
Nclust = recommended;
if ~mainfigure
    figure;
else
    AX = axes(fig,'Position',[0.2687 0.0654 0.2151 0.2574]);
end
plot(default_groups,idx);
hold on
plot(recommended,idx(id),'*r')
hold off
xlabel('number of groups')
ylabel([testmethod, ' index value'])

function idx = local_dunn_test(CL, dist)

mCL = max(CL);
min_inter=[];   % minimal distance inter-group
max_intra=[];   % maximal distance intra-group
for igroup = 1:mCL
    g_i = find(CL==igroup);
    g_o = find(CL~=igroup);
    min_inter(igroup) = min(min(dist(g_i, g_o)));
    max_intra(igroup) = max(max(dist(g_i, g_i)));
end
min_inter=min(min_inter);
max_intra=max(max_intra);

idx = min_inter/max_intra;


function DBI = local_davies_test(idx, Xp)
g = max(idx);
db=zeros(g);
for i=1:g-1
    
    g_i=find(idx==i);           % index of ith group
    c_i=mean(Xp(g_i,:),1);        % centroid of ith group
    
    c_i_rep=repmat(c_i,numel(g_i),1);
    s_i=mean(sqrt(sum((c_i_rep-Xp(g_i,:)).^2,2))); % standard deviation of ith group
    
    for j=i+1:g
        
        g_j=find(idx==j);       % index of jth group
        c_j=mean(Xp(g_j,:));    % centroid of ith group
        c_j_rep=repmat(c_j,numel(g_j),1);
        s_j=mean(sqrt(sum((c_j_rep-Xp(g_j,:)).^2,2))); % standard deviation of ith group
        
        d_ij=sqrt(sum((c_i-c_j).^2)); % Distance Between centroids
        
        db(i,j)=(s_i+s_j)/d_ij;
        db(j,i)=(s_i+s_j)/d_ij;
    end
end

DBI=sum(max(db))/g;