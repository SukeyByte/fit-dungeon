using UnityEngine;
using UnityEngine.UI;

namespace FitDungeon.Game
{
    /// <summary>
    /// 像素小人角色控制器 - 根据动作做出响应
    /// </summary>
    public class PixelCharacterController : MonoBehaviour
    {
        [Header("角色设置")]
        [SerializeField] private SpriteRenderer spriteRenderer;
        [SerializeField] private float moveSpeed = 5f;
        [SerializeField] private float attackDuration = 0.5f;
        
        [Header("像素精灵")]
        [SerializeField] private Sprite idleSprite;
        [SerializeField] private Sprite attackSprite;
        [SerializeField] private Sprite hurtSprite;
        
        // 状态
        public enum CharacterState { Idle, Attacking, Hurting }
        private CharacterState currentState = CharacterState.Idle;
        private float stateTimer = 0f;
        
        // 攻击特效
        [SerializeField] private ParticleSystem attackEffect;
        [SerializeField] private Transform attackPoint;
        
        /// <summary>
        /// 当前状态
        /// </summary>
        public CharacterState State => currentState;
        
        private void Update()
        {
            // 状态计时器
            if (stateTimer > 0)
            {
                stateTimer -= Time.deltaTime;
                if (stateTimer <= 0)
                {
                    SetState(CharacterState.Idle);
                }
            }
        }
        
        /// <summary>
        /// 执行攻击（深蹲触发）
        /// </summary>
        public void Attack()
        {
            if (currentState == CharacterState.Attacking) return;
            
            SetState(CharacterState.Attacking);
            stateTimer = attackDuration;
            
            // 播放攻击特效
            if (attackEffect != null)
            {
                attackEffect.Play();
            }
            
            Debug.Log("角色攻击！");
        }
        
        /// <summary>
        /// 受伤
        /// </summary>
        public void Hurt()
        {
            SetState(CharacterState.Hurting);
            stateTimer = 0.3f;
        }
        
        /// <summary>
        /// 设置状态
        /// </summary>
        private void SetState(CharacterState newState)
        {
            currentState = newState;
            UpdateSprite();
        }
        
        /// <summary>
        /// 更新精灵图
        /// </summary>
        private void UpdateSprite()
        {
            if (spriteRenderer == null) return;
            
            switch (currentState)
            {
                case CharacterState.Idle:
                    spriteRenderer.sprite = idleSprite;
                    break;
                case CharacterState.Attacking:
                    spriteRenderer.sprite = attackSprite;
                    break;
                case CharacterState.Hurting:
                    spriteRenderer.sprite = hurtSprite;
                    break;
            }
        }
        
        /// <summary>
        /// 移动角色
        /// </summary>
        public void Move(Vector2 direction)
        {
            transform.Translate(direction * moveSpeed * Time.deltaTime);
        }
    }
}
