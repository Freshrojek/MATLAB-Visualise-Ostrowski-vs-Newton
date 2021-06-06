% f: a function to be used
% df: the derivative function of f
% resolution: the resolution of the graph (recommended 400)
function OstrowskivsNewton(f, df, resolution)
    
    % Get unique colours
    function colour = getUniqueColour(n, maxN)
        h = ((359 /maxN) *n)/359;
        s = 1;
        v = 1;
        colour = hsv2rgb([h,s,v]);


    end
    % make image
    function filledImage = makeImage(resolutionImage, N)
        Size = size(resolutionImage, 1);
        blankImage = ones(Size, Size, 3);
        uniqueInitial = unique(round(resolutionImage(~isnan(resolutionImage)), 3));
        filledImage = zeros(size(blankImage));

        for a = 1:length(uniqueInitial)
            
            Mask = round(resolutionImage, 3) == uniqueInitial(a);
            colour = getUniqueColour(a, length(uniqueInitial));
            blankImage(:, :, 1) = colour(1);
            blankImage(:, :, 2) = colour(2);
            blankImage(:, :, 3) = colour(3);

            filledImage = filledImage + bsxfun(@times, blankImage, cast(Mask, "like", blankImage));
        end


        blankImage = ones(Size, Size, 3);
        LogN = log(N);
        NMask = LogN / max(max(LogN));
        filledImage = (filledImage / 2) + (bsxfun(@times, blankImage, cast(NMask, "like", blankImage)) / 2);


        grey = isnan(resolutionImage);
        filledImage(grey) = 0.5;

    end

    rangeFirst = -1:2/resolution:1;
    rangeSecond = -1:2/resolution:1;

    resolutionNewton = zeros(resolution, resolution);
    resolutionOstrowski = zeros(resolution, resolution);

    NNewton = zeros(resolution, resolution);
    NOstrowski = zeros(resolution, resolution);

    for i = 1:length(rangeSecond) - 1
        for j = 1:length(rangeFirst) - 1
            x = rangeFirst(j) + rangeSecond(i) * 1i;
            [resolutionNewton(i, j), NNewton(i, j)] = Newton_task6(f, df, x, 1e-5, 100);
            [resolutionOstrowski(i, j), NOstrowski(i, j)] = Ostrowski_task6(f, df, x, 1e-5, 100);
        end
    end
    

    imageNewton = makeImage(resolutionNewton, NNewton);
    imageOstrowski = makeImage(resolutionOstrowski, NOstrowski);

    subplot(1, 2, 1);
    imshow(imageNewton);
    title("Newton");

    subplot(1,2,2);
    imshow(imageOstrowski);
    title("Ostrowski");



end
