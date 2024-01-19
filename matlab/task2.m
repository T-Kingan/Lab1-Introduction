% rotate.m

% load clown image
load clown
imageData = clown; % Replace 'X' with 'clown' if clown is indeed the image data

% Rotate the image by 45 degrees
%rotatedImage = reverseMapping(imageData, pi/4); % Rotate by 45 degrees
shearImage = Shear(imageData, 0.1, 0.5);

% Display the rotated image
imshow(rotatedImage);

% Ensure there are no script commands after this line.

function Out = forwardMapping(In, Theta)
    % Size of the input image
    [rows, cols] = size(In);
    
    % Calculate the center of the image
    centerX = cols / 2;
    centerY = rows / 2;

    % Create the rotation matrix
    R = [cos(Theta) -sin(Theta); sin(Theta) cos(Theta)];
    
    % Initialize the output image
    Out = zeros(rows, cols);

    % Perform forward mapping
    for x = 1:cols
        for y = 1:rows
            % Apply the rotation matrix
            newCoord = R * ([x; y] - [centerX; centerY]) + [centerX; centerY];

            % Nearest neighbor interpolation
            newCoord_rounded = round(newCoord);

            % Check if the new coordinates are within the bounds of the output image
            if (newCoord_rounded(1) >= 1 && newCoord_rounded(1) <= cols && ...
                newCoord_rounded(2) >= 1 && newCoord_rounded(2) <= rows)
                % Assign the pixel value to the destination image
                Out(newCoord_rounded(2), newCoord_rounded(1)) = In(y, x);
            end
        end
    end
end

function Out = reverseMapping(In, Theta)
    % Size of the input image
    [rows, cols] = size(In);
    
    % Calculate the center of the image
    centerX = cols / 2;
    centerY = rows / 2;

    % Create the rotation matrix
    R_inv = inv([cos(Theta) -sin(Theta); sin(Theta) cos(Theta)]);
    
    % Initialize the output image
    Out = zeros(rows, cols);

    % Perform forward mapping
    for x = 1:cols
        for y = 1:rows
            % Apply the inverse rotation matrix to find the source coordinates
            sourceCoord = R_inv * ([x; y] - [centerX; centerY]) + [centerX; centerY];
            
            % Nearest neighbor interpolation
            sourceCoord_rounded = round(sourceCoord);

            % Check if the source coordinates are within the bounds of the input image
            if (sourceCoord_rounded(1) >= 1 && sourceCoord_rounded(1) <= cols && ...
                sourceCoord_rounded(2) >= 1 && sourceCoord_rounded(2) <= rows)
                % Assign the pixel value from the source image to the destination image
                Out(y, x) = In(sourceCoord_rounded(2), sourceCoord_rounded(1));
            else
                % If the source pixel is outside the image, paint it black
                Out(y, x) = 0;
            end
        end
    end
end

function Out = Shear(In, Xshear, Yshear)
    % Size of the input image
    [rows, cols] = size(In);

    % Calculate the center of the image
    centerX = cols / 2;
    centerY = rows / 2;

    % Initialize the output image
    Out = zeros(rows, cols);

    % Create the rotation matrix
    R = [1 Yshear; Xshear 1];

    % Perform forward mapping
    for x = 1:cols
        for y = 1:rows
            % Find the corresponding position in the input image
            sourceCoord = inv(shearMatrix) * ([x; y] - [centerX; centerY]) + [centerX; centerY];

            % Nearest neighbor interpolation
            sourceCoord_rounded = round(sourceCoord);

            % Check if the source coordinates are within the bounds
            if (sourceCoord_rounded(1) >= 1 && sourceCoord_rounded(1) <= cols && ...
                sourceCoord_rounded(2) >= 1 && sourceCoord_rounded(2) <= rows)
                % Assign pixel value from source to destination
                Out(y, x) = In(sourceCoord_rounded(2), sourceCoord_rounded(1));
            else
                % Paint it black if outside the image
                Out(y, x) = 0;
            end
        end
    end
end