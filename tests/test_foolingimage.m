


tic;
load cnn;
img = test_x(:,:,1);
label = test_y(:,1);
img_train_batch=zeros(28,28,50);
img_test_batch = zeros(10,50);
for ii=1:50
    img_train_batch(:,:,ii) = img;
    img_test_batch(:,ii) = label;
end

conf = cnntest_fool(cnn, img_train_batch, img_test_batch);
conf

% add random noise
%img_noise_new = img;

img_noise_new = rand(28,28)*0.6;
confx = [0];
conflist = [0];
ite = 0;
while(true)
    ite = ite +1;
    %img_noise = img_noise_new * 0.95 + rand(28,28) * 0.05;
    rand_x = int8(27*rand(1))+1;
    rand_y = int8(27*rand(1))+1;
    img_noise = img_noise_new;
    img_noise(rand_x,rand_y) = img_noise_new(rand_x,rand_y) * 0.95 + 0.05 * (rand(1)-0.5);
    img_train_batch=zeros(28,28,50);
    img_test_batch = zeros(10,50);
    for ii=1:50
        img_train_batch(:,:,ii) = img_noise;
        img_test_batch(:,ii) = label;
    end
    conf_new = cnntest_fool(cnn, img_train_batch, img_test_batch);
    
    if conf_new>conflist(end)
        img_noise_new = img_noise;
        confx(end+1) = ite;
        conflist(end+1) = conf_new;
        pstr = sprintf('update, ite = %d, conf = %f',ite,conflist(end))
    end
    if conf_new>0.99
        break;
    end
    if mod(ite,1000)==1
        pstr = sprintf('ite = %d, conf = %f',ite,conflist(end))
        pth = sprintf('svimgs/svimg_%d.png',ite);
        imwrite(img_noise',pth);
    end
end
save('confx.mat','confx');
save('conflist.mat','conflist');
toc;