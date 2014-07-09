function [L, R] = getBinauralDepth(d_map, w)
%getBinauralDepth Generates a depth map for left and right ears.
%   We assume that the depth map given is with respect to the center of the
%   head so we generate the depth maps l and r for the left and right ears
%   respectively with law of cosines.
%
%   Using the Microsoft Kinect we have 57 degrees of horizontal vision and
%   43 degrees of vertical vision.
deg_horz = 57;
deg_vert = 43;

[len, width] = size(d_map);

%Splitting the degrees in the horizontal plane
vec1 = [-(deg_horz/2):deg_horz/width:(deg_horz/2)];

for i=1:length(vec1)
    %If the pixel is to the left of the y axis
    if(vec1(i) < 0)
        thetaR(i) = 90 - vec1(i);
        thetaL(i) = 90 + vec1(i);
    else
    if(vec1(i) > 0)
        thetaR(i) = 90 - vec1(i);
        thetaL(i) = 90 + vec1(i);
    else
        thetaR(i) = vec1(i);
        thetaL(i) = vec1(i);
    end
    end
end
        
%This contains the degrees from the center of the camera for every pixel in
%the image with respect to the origin x = 0 for right and left ears
%respectively.
R_deg = repmat(thetaR,len,1);
L_deg = repmat(thetaL,len,1);

R = zeros(size(d_map));
L = zeros(size(d_map));

%Loop through every depth and calculate left and right ear distances
for i=1:len
    for j=1:width
        d = d_map(i,j);
        thetaR = R_deg(i,j);
        thetaL = L_deg(i,j);
        %Law of Cosines
        R(i,j) = sqrt((w/2)^2 + d^2 + 2*d*(w/2)*cos(thetaR));
        L(i,j) = sqrt((w/2)^2 + d^2 + 2*d*(w/2)*cos(thetaL));
    end
end

%Checks
assert(size(R,1) == len);
assert(size(R,2) == width);
assert(size(L,1) == len);
assert(size(L,2) == width);
end

