# DAC 2012 Routability-Driven Placement 复现要点

对 g-edge `e`，容量、blockage、需求分别为 `c_e`、`b_e`、`w_e`：`OF(e)=max(w_e+b_e-c_e,0)`；TOF 为 overflow 总和，MOF 为最大 overflow；`Cong(e)=100×(w_e+b_e)/c_e`；`ACE(x)` 是拥塞最高的前 `x%` g-edge 的平均值。

至少保存 `ACE(0.5/1/2/5/10)`。较小 x 描述局部热点，较大 x 描述广泛拥塞。TOF 无法可靠区分集中热点和均匀轻度 overflow，因此不能单独使用。

`PWC=Σ(K_x×ACE(x))/ΣK_x`（x 为 0.5、1、2、5），`RC=max(100,PWC)`，routability metric 为 `HPWL×(1+PF×(RC-100))`；论文示例使用 `PF=0.03`。Contest metric 还乘以 `(1+RuntimeFactor)`。

DAC 2012 扩展 Bookshelf：`.route` 描述布线网格、层、容量、线宽/间距、via、blockage 和 RLM pin 层；`.shapes` 描述非矩形固定节点；`terminal_NI` 在 placement 中可与 movable node 重叠。数据转换不得丢弃这些信息。

