function [redB,s,S,U,V] = svd_components(B)
% [redB,s,S,U,V] = svd_components(B) - performs singular value decomposition on
% the binary matrix B and returns the significant singular values which
% represent distinct clusters
%
%   INPUT:
%       B - binary matrix representing significantly similar time vectors
%       (TxT)
%
%   OTPUTS:
%       redB - N dimensional matrix - decomposition of B. N = number of
%               significant singular values
%       s - reduced singular value matrix S diagonal containing onl
%       significant singular values
%       S - full singular valuue matrix
%       U - left unitary matrix of orthinormal bases
%       V - right unitary matrix of orthonormal bases
%
%part of ZENITH
toplot = 1;
[U,S,V] = svd(B);


s = diag(S);

%check
BB = zeros(size(B));
for is = 1:numel(s)
    BB = BB+s(is).*U(:,is)*V(:,is)';
end
b = round(BB)==B;
if sum(sum(b)) == numel(B)
    fprintf('svd decomposition successful\n');
else
    fprintf('svd decomposition does not reproduce binary matrix\n');
end


N = 6;

for in = 1:N
    redB(in,:,:) = s(in).*U(:,in)*V(:,in)';
end


if toplot
    F = figure;
    set(F,'units', 'normalized', 'position', [0.0995 0.0954 0.81 0.75])

    AX1 = autoaxes(F,2,1,[0.05 0.75, 0.05 0.05], [0, 0.05]);
    AX2 = autoaxes(F,2,ceil(N/2),[0.25 0.025 0.05 0.05],[0.025,0.05]);
    
    axes(AX1(1));
    imagesc(B);
    title('full activation matrix');
    axes(AX1(2));
    plot(s,'k-','linew',2);
    ylabel('magnitude');
    xlabel('index');
    set(AX1(2),'xscale','log');
    xlim([1,30]);
    for in = 1:N
        axes(AX2(in));
        m(:,:) = redB(in,:,:);
        imagesc(m);
        title(['component ',num2str(in)]);
    end
end